param ( 
    [string]$env 
)

# Applications
.\substitute.ps1 -templatefile app-traefik-template.yaml -outputfile applications/traefik.yaml -env $env
.\substitute.ps1 -templatefile app-external-dns-template.yaml -outputfile applications/external-dns.yaml -env $env
.\substitute.ps1 -templatefile app-external-secrets-template.yaml -outputfile applications/external-secrets.yaml -env $env
.\substitute.ps1 -templatefile app-reloader-template.yaml -outputfile applications/reloader.yaml -env $env

# Kubernetes resources
.\substitute.ps1 -templatefile resources-external-dns-template.yaml -outputfile external-dns/external-dns.yaml -env $env
.\substitute.ps1 -templatefile resources-external-secrets-template.yaml -outputfile external-secrets/external-secrets.yaml -env $env


# Other files
.\substitute.ps1 -templatefile secretfile-template.json -outputfile secretfile.json -env $env
.\substitute.ps1 -templatefile argocd-values-template.yaml -outputfile argocd-values.yaml -env $env



