EXECUTE SERVICE
    IN COMPUTE POOL CONTAINER_DEMO_POOL
    FROM SPECIFICATION $$
spec:
  containers:
    - name: modeling
      image: sfsenorthamerica-demo-jdemlow.registry.snowflakecomputing.com/container_demo_db/public/image_repo/modeling
      env:
        SNOWFLAKE_WAREHOUSE: CONTAINER_DEMO_WH
        NOTEBOOK_FILE: "SPCSDataScience/job_nbs/99b_predict_randomforest.ipynb"
        FILE_NAME: predict_randomforest
      command:
        - "/bin/bash"
        - "-c"
        - "source /opt/venv/bin/activate && { datetime=$(date +'%Y%m%d_%H%M%S'); jupyter nbconvert --execute --inplace --allow-errors --ExecutePreprocessor.timeout=-1 --NotebookApp.token='${JUPYTER_TOKEN}' ${NOTEBOOK_FILE} --output=./RanJobs/${FILE_NAME}executed_${datetime}.ipynb; }"
      volumeMounts:
        - name: juypter-nbs
          mountPath: /home/jupyter
  networkPolicyConfig:
      allowInternetEgress: true
  volumes:
    - name: juypter-nbs
      source: "@volumes/juypter-nbs"
      uid: 1000
      gid: 1000
$$;
