$password = "P@55w0rd123!" | ConvertTo-SecureString -AsPlainText -Force
 Set-LocalUser -Name "Administrator" -Password $password