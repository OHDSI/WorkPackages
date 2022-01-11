# Render the website
rmarkdown::render_site("Rmd")

# Build the back-end database
connectionDetails <- DatabaseConnector::createConnectionDetails(
  dbms = "postgresql",
  server = paste(keyring::key_get("workPackagesServer"),
                 keyring::key_get("workPackagesDatabase"),
                 sep = "/"),
  user = keyring::key_get("workPackagesOwnerUser"),
  password = keyring::key_get("workPackagesOwnerPassword"))

connection <- DatabaseConnector::connect(connectionDetails)

DatabaseConnector::executeSql(connection, "SET search_path TO work_packages;")

pathToSql <- system.file("sql", "postgresql", "CreateDatabaseTables.sql", package = "WorkPackages")
sql <- SqlRender::readSql(pathToSql)
DatabaseConnector::executeSql(connection, sql)

DatabaseConnector::executeSql(connection, "grant select on all tables in schema work_packages to legend;") # So that data.ohdsi.org shiny apps can access
DatabaseConnector::executeSql(connection, "grant select on all tables in schema work_packages to work_packages_readonly;")

exampleData <- data.frame(
  package_id = c(1,2,3),
  text_field = c("Test Text Example 1", "Test Text Example 2", "Test Text Example 3"),
  another_field = c("Extended text 1", "Extended text 2", "Extended text 3")
)

DatabaseConnector::insertTable(connection, tableName = "package_descriptions",
                               data = exampleData, dropTableIfExists = FALSE, createTable = FALSE)

DatabaseConnector::disconnect(connection)
