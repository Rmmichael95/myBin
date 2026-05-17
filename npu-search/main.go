package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"math"
	"net/http"
	"os"
	"path/filepath"
	"sort"
	"strings"
)

type EmbeddingRequest struct {
	Model string `json:"model"`
	Input string `json:"input"`
}

type EmbeddingResponse struct {
	Data []struct {
		Embedding []float64 `json:"embedding"`
	} `json:"data"`
}

// Upgraded Schema to support multi-chunk positioning inside a single file
type NoteChunk struct {
	Line      int       `json:"line"`
	Header    string    `json:"header"`
	Embedding []float64 `json:"embedding"`
}

type VectorPayload struct {
	Filepath string      `json:"filepath"`
	Chunks   []NoteChunk `json:"chunks"`
}

type SearchResult struct {
	Score    float64
	Filepath string
	Line     int
	Header   string
}

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Usage: npu-search <query>")
		os.Exit(1)
	}
	query := strings.Join(os.Args[1:], " ")

	// 1. Convert search query to a vector via the unified NPU engine
	queryVector, err := getQueryEmbedding(query)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error fetching query embedding: %v\n", err)
		os.Exit(1)
	}

	// 2. Resolve XDG Cache Home
	cacheBase := os.Getenv("XDG_CACHE_HOME")
	if cacheBase == "" {
		home, err := os.UserHomeDir()
		if err != nil {
			os.Exit(1)
		}
		cacheBase = filepath.Join(home, ".local", "cache")
	}
	cacheDir := filepath.Join(cacheBase, "npu_vectors")

	files, err := os.ReadDir(cacheDir)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading vector cache: %v\n", err)
		os.Exit(1)
	}

	var results []SearchResult

	// 3. Scan through cached notes and evaluate the vector math per-chunk
	for _, file := range files {
		if !strings.HasSuffix(file.Name(), ".json") {
			continue
		}

		fullPath := filepath.Join(cacheDir, file.Name())
		f, err := os.Open(fullPath)
		if err != nil {
			continue
		}

		var payload VectorPayload
		err = json.NewDecoder(f).Decode(&payload)
		f.Close()
		if err != nil || len(payload.Chunks) == 0 {
			continue
		}

		// Calculate similarity score for each individual section
		for _, chunk := range payload.Chunks {
			if len(chunk.Embedding) == 0 {
				continue
			}

			score := cosineSimilarity(queryVector, chunk.Embedding)

			// Calibrated similarity window for embed-gemma:300m granular chunks
			if score > 0.28 {
				results = append(results, SearchResult{
					Score:    score,
					Filepath: payload.Filepath,
					Line:     chunk.Line,
					Header:   chunk.Header,
				})
			}
		}
	}

	// 4. Sort results by absolute conceptual relevance
	sort.Slice(results, func(i, j int) bool {
		return results[i].Score > results[j].Score
	})

	// 5. Output in standard grep format: file:line: [Header]
	limit := 10
	if len(results) < limit {
		limit = len(results)
	}
	for i := 0; i < limit; i++ {
		fmt.Printf("%s:%d: [%s]\n", results[i].Filepath, results[i].Line, results[i].Header)
	}
}

func getQueryEmbedding(query string) ([]float64, error) {
	reqPayload := EmbeddingRequest{
		Model: "embed-gemma:300m",
		Input: query,
	}
	body, err := json.Marshal(reqPayload)
	if err != nil {
		return nil, err
	}

	apiKey := os.Getenv("FLM_API_KEY")
	if apiKey == "" {
		apiKey = "lemonade"
	}

	// Target the explicit IPv4 loopback to avoid the systemd IPv6 stall
	req, err := http.NewRequest("POST", "http://127.0.0.1:52625/v1/embeddings", bytes.NewBuffer(body))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+apiKey)

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("API status: %d", resp.StatusCode)
	}

	respBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var res EmbeddingResponse
	if err := json.Unmarshal(respBytes, &res); err != nil {
		return nil, err
	}

	if len(res.Data) == 0 {
		return nil, fmt.Errorf("empty vector matrix")
	}

	return res.Data[0].Embedding, nil
}

func cosineSimilarity(v1, v2 []float64) float64 {
	if len(v1) != len(v2) {
		return 0
	}
	var dotProduct, normA, normB float64
	for i := 0; i < len(v1); i++ {
		dotProduct += v1[i] * v2[i]
		normA += v1[i] * v1[i]
		normB += v2[i] * v2[i]
	}
	if normA == 0 || normB == 0 {
		return 0
	}
	return dotProduct / (math.Sqrt(normA) * math.Sqrt(normB))
}
