![image](https://github.com/user-attachments/assets/ff7e58cc-cd38-4a2b-865a-3b9873c7bd9a)


Terraform apply will return output EC2 instance ID for developer can use SSM function.


# tf-repo

To connect to bastion host, run the below command

```bash
#get INSTANCE_ID from terraform output
INSTANCE_ID="i-0a416c36830441fff"
aws ssm start-session --target $INSTANCE_ID \
                       --document-name AWS-StartPortForwardingSession \
                       --parameters '{"portNumber":["22"],"localPortNumber":["2222"]}'
```
