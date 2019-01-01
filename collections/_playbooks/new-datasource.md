---
name: >-
  New DataSource
identifier: >-
  NewDS
steps:
 - Clone the <a href='https://github.com/MetroPlatform/Metro-DataSources'>repository</a>
 - New branch new/datasorurce_name
 - Copy an existing DataSource folder
 - Update the manifest.json
 - Update the schema.json
 - Run <code>python -m http.server 5000</code>
 - Enable developer mode and enter http://127.0.0.1:5000/
public: true
---