
#!/bin/bash
### Container appuio/oc Has OC tools####



#set var to find POD we are looking for
export NAMESPACE=glauth
export FILEPATH=/home/ldap/db/config.cfg

### you will need to enter info for refresh token indicated below. 
#export BEAR=$(curl https://api.dropbox.com/oauth2/token -d refresh_token=ryhoFT7pOdQAAAAAAASW8PJIXX8UqILZvfUAf-bbbasdfasd1235WFq0rU -d grant_type=refresh_token  -d client_id=asdfasdfsdfsd -d client_secret=asdfasdfsdfsd |  awk -F '"' '{print $4}')


### Need to set the pod we are looking for some issue for searching here as if the name is too common this script will provide more than one result and fail####
export POD=glauth
export PODNAME=$(oc get pods -n $NAMESPACE | grep -e $POD | awk '{print $1}')


oc rsync $PODNAME:$FILEPATH . -n $NAMESPACE


## post data to Dropbox look at config.cfg is my example file please upload what you need to the path you need. config drops to the root of the directory
## The command upload will update the file and only make changes to the file if a change is needed

curl -X POST https://content.dropboxapi.com/2/files/upload  --header "Authorization: Bearer $BEAR" --header "Dropbox-API-Arg: {\"path\": \"/config.cfg\",\"mode\":\"overwrite\"}" --header "Content-Type: application/octet-stream"  --data-binary @config.cfg


sleep 3600
