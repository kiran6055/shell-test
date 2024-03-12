TO=$1
SUBJECT=$2

#sed -e 's/[]\/$*.^[]/\\&/g' this is used to esacpe spacial charaters in the we need to used this command as shown in below
BODY_CONTENT=$(sed -e 's/[]\/$*.^[]/\\&/g' <<< $3)
echo "escaped content: $BODY_CONTENT"
NAME=$4
ALERT_TYPE=$2


template="/home/ec2-user/shell-test/shelltopics/template/template.html"

final_content=$(sed -e "s/Team/$NAME/g" -e "s/BODY_CONTENT/$BODY_CONTENT/g" -e "s/ALERT_TYPE/$ALERT_TYPE/g" "$template")
#echo "final_content is : $final_content" 

echo -e "$final_content"  | mail -s "$(echo -e "$SUBJECT\nContent-Type: text/html")" $TO


# sneding html content in mailcommand we need to use the below
