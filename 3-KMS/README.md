```
aws kms encrypt --key-id <your-key-id> --region <your-region> --plaintext fileb://<file-name> --output text --query CiphertextBlob > <name-you-want>
```
