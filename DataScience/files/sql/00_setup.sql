
// Create an CONTAINER_USER_ROLE with required privileges
USE ROLE ACCOUNTADMIN;
CREATE ROLE CONTAINER_USER_ROLE;
USE ROLE SYSADMIN;
GRANT CREATE DATABASE ON ACCOUNT TO ROLE CONTAINER_USER_ROLE;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE CONTAINER_USER_ROLE;
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE CONTAINER_USER_ROLE;
USE ROLE ACCOUNTADMIN;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE CONTAINER_USER_ROLE;
GRANT MONITOR USAGE ON ACCOUNT TO  ROLE  CONTAINER_USER_ROLE;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE CONTAINER_USER_ROLE;
GRANT IMPORTED PRIVILEGES ON DATABASE snowflake TO ROLE CONTAINER_USER_ROLE;
GRANT ROLE CONTAINER_USER_ROLE to role ACCOUNTADMIN;

CREATE OR REPLACE WAREHOUSE CONTAINER_DEMO_WH
  WAREHOUSE_SIZE = XSMALL
  AUTO_SUSPEND = 120
  AUTO_RESUME = TRUE;
GRANT OWNERSHIP ON WAREHOUSE CONTAINER_DEMO_WH TO ROLE CONTAINER_USER_ROLE REVOKE CURRENT GRANTS;

USE ROLE CONTAINER_USER_ROLE;
CREATE OR REPLACE DATABASE CONTAINER_DEMO_DB;
USE DATABASE CONTAINER_DEMO_DB;

CREATE STAGE IF NOT EXISTS SPECS
  ENCRYPTION = (TYPE='SNOWFLAKE_SSE')
  DIRECTORY = ( ENABLE = TRUE ) 
  COMMENT = 'Store Docker Image Commands for SPCS';

CREATE STAGE IF NOT EXISTS VOLUMES
  ENCRYPTION = (TYPE='SNOWFLAKE_SSE')
  DIRECTORY = (ENABLE = TRUE)
  COMMENT = 'Saving Data As We Develop In Snowflake';

CREATE STAGE IF NOT EXISTS RDF_MODEL 
  ENCRYPTION = (TYPE='SNOWFLAKE_SSE')
	DIRECTORY = ( ENABLE = TRUE ) 
	COMMENT = 'For This Use Case';

CREATE IMAGE REPOSITORY CONTAINER_DEMO_DB.PUBLIC.IMAGE_REPO 
COMMENT = 'This is for modeling useage';

GRANT READ ON STAGE CONTAINER_DEMO_DB.PUBLIC.RDF_MODEL TO ROLE CONTAINER_USER_ROLE;
GRANT WRITE ON STAGE CONTAINER_DEMO_DB.PUBLIC.RDF_MODEL TO ROLE CONTAINER_USER_ROLE;
GRANT READ ON IMAGE REPOSITORY CONTAINER_DEMO_DB.PUBLIC.IMAGE_REPO TO ROLE CONTAINER_USER_ROLE;
GRANT WRITE ON IMAGE REPOSITORY CONTAINER_DEMO_DB.PUBLIC.IMAGE_REPO TO ROLE CONTAINER_USER_ROLE;