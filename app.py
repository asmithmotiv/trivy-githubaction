"""
Simple demo app - not meant to run, just to provide context for the repo.
"""
import os

# Hardcoded secrets - intentionally here for Trivy secret scanning demo
AWS_ACCESS_KEY_ID = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_ACCESS_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
GITHUB_TOKEN = "ghp_aBcDeFgHiJkLmNoPqRsTuVwXyZ012345678"

def get_db():
    return DATABASE_URL

if __name__ == "__main__":
    print("Demo app - for Trivy scanning only")
