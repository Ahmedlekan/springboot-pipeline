#!/bin/bash

# Health check for the running container
curl -is --max-redirs 10 http://localhost:8080 -L | grep -w "HTTP/1.1 200" > /dev/null
if [ $? -ne "0" ]; then
   echo "============================================================="
   echo "Unable to reach Spring Boot application on port 8080 !!"
   echo "============================================================="
   exit 1  # Important: Make the script fail if health check fails
else
   echo "================="
   echo "Smoke Test passed"
   echo "================="
fi

# Check Trivy results (if file exists)
if [ -f "trivyresults.txt" ]; then
  grep "CRITICAL" trivyresults.txt > /dev/null
  if [ $? -ne "0" ]; then
     echo "============================================================="
     echo "Docker Image ${IMAGE_NAME} is ready for deployment"
     echo "============================================================="
  else
     echo "============================================================="
     echo "Docker Image ${IMAGE_NAME} has CRITICAL vulnerabilities!!"
     echo "============================================================="
     exit 1  # Fail if critical vulnerabilities found
  fi
else
  echo "No Trivy scan results found"
fi

