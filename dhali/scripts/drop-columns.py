#!/usr/bin/env python

import glob

import pandas as pd

# Get a list of all CSV files in the directory
csv_files = glob.glob("*.csv")

out_file = "new-clean.csv"

fields = [
    "Subscribe Date (UTC-05)",
    "Method",
    "Complete General Contact Profile\\Email Address",
    "Complete General Contact Profile\\First Name",
    "Complete General Contact Profile\\Middle Name",
    "Complete General Contact Profile\\Last Name",
    "Complete General Contact Profile\\Full Name",
    "Complete General Contact Profile\\Title",
    "Complete General Contact Profile\\Company",
    "Complete General Contact Profile\\Address - Street",
    "Complete General Contact Profile\\Address - City",
    "Complete General Contact Profile\\Address - Zip",
    "Complete General Contact Profile\\Address - State",
    "Complete General Contact Profile\\Phone Number",
    "Complete General Contact Profile\\WorkAdd - Street",
    "Complete General Contact Profile\\WorkAdd - City",
    "Complete General Contact Profile\\WorkAdd - State",
    "Complete General Contact Profile\\WorkAdd - Zip",
    "Complete General Contact Profile\\Work Phone Number",
    "Complete General Contact Profile\\License Type",
    "Complete General Contact Profile\\License Status",
    "Complete General Contact Profile\\Address - St.-City-State-Zip",
    "Complete General Contact Profile\\WordAdd - Full",
    "Complete General Contact Profile\\Address - Street 2",
    "Complete General Contact Profile\\WorkAdd - Street 2",
    "Complete General Contact Profile\\DOB-mmddyyyy",
    "Complete General Contact Profile\\LicExp-mmddyyyy",
    "Complete General Contact Profile\\LicBeg-mmddyyyy",
    "Complete General Contact Profile\\License Number",
    "Complete General Contact Profile\\NPN",
    "Complete General Contact Profile\\Import Date",
    "Complete General Contact Profile\\Bounced by Email provider",
    "Complete General Contact Profile\\Subscribe Date - orig.",
    "Complete General Contact Profile\\DB Source",
    "Complete General Contact Profile\\State - non.res Source",
    "Complete General Contact Profile\\Resident",
    "Complete General Contact Profile\\CE Compliance",
    "Complete General Contact Profile\\IsCustomer Yes-No",
    "Complete General Contact Profile\\Address - Province",
    "Complete General Contact Profile\\Address - Country",
    "Complete General Contact Profile\\CustomerID",
    "Complete General Contact Profile\\CustomerCompanyID",
    "Complete General Contact Profile\\z_IsAffiliate",
    "Complete General Contact Profile\\TransferFrom",
    "Complete General Contact Profile\\ExpYr_E-O",
    "Complete General Contact Profile\\AccountRegistrationDate",
    "Complete General Contact Profile\\AffiliateName",
    "Complete General Contact Profile\\RegistrationDate",
    "Complete General Contact Profile\\Year",
    "Unsubscribe Date",
    "Last Open Date (UTC-05)",
    "Last Read Date (UTC-05)",
    "Last Click Date (UTC-05)",
    "Last Send Date (UTC-05)",
    "Country",
    "Region",
    "Postal Code",
    "Preferred Email Client",
    "Email Key",
    "Universal Email Key (SHA256)",
    "Unsubscribe Date (UTC-05)",
]

df = pd.DataFrame()

for csv_file in csv_files:
    # Load the CSV file into a DataFrame
    df = pd.read_csv(csv_file, dtype=str, on_bad_lines="skip")
    # Remove the specified column
    df.drop(columns=fields, inplace=True)
    # write to file
    df.to_csv(out_file, index=False)
