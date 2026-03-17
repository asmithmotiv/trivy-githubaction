"""
Simple demo app - not meant to run, just to provide context for the repo.
"""
import os

# Hardcoded secrets - intentionally here for Trivy secret scanning dem
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
GITHUB_TOKEN = "ghp_aBcDeFgHiJkLmNoPqRsTuVwXyZ012345678"
DATABASE_URL = "postgresql://admin:SuperSecret123!@prod-db.example.com:5432/myapp"
SENDGRID_API_KEY = "SG.abcdefghijklmnopqrstuvwx.ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890abcde"

def get_db():
    return DATABASE_URL

if __name__ == "__main__":
    print("Demo app - for Trivy scanning only")
