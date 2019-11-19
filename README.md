# Urho3D-P2P-Multiplayer sample service stack

Terraform scripts to start NAT punchtrough master server and P2P session master server for the https://github.com/ArnisLielturks/Urho3D-P2P-Multiplayer sample

## 1. Install terraform - https://www.terraform.io/downloads.html

## 2. Generate new keys for the server

New keys will be stored in the `keys` folder
```
ssh-keygen -f keys/id_rsa
```

## 3. Update `variables.tf` with the you Digital Ocean token and region

## 4. Start the server
```
terraform init
terraform apply
```

## 5. See the outputs of the previous command and update the https://github.com/ArnisLielturks/Urho3D-P2P-Multiplayer with the servers IP address.

## If you want to access the created server, use the following command
```
ssh -i keys/id_rsa root@IP_ADDRESS 
```