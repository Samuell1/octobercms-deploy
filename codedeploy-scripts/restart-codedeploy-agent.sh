# restart codedeploy-agent to prevent memory leak https://github.com/aws/aws-codedeploy-agent/issues/32
at -M now + 2 minute <<< $'sudo service codedeploy-agent restart'
