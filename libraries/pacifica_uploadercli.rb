# pacifica cookbook module
module PacificaCookbook
  require_relative 'pacifica_base'
  # Manages the Pacifica archive interface service
  class PacificaUploaderCLI < PacificaBase
    resource_name :pacifica_uploadercli

    property :name, String, name_property: true
    property :pip_install_opts, Hash, default: {
      command: '-m pip install git+https://github.com/pacifica/pacifica-cli-uploader.git@master',
    }
    property :config_opts, Hash, default: {
      variables: {
        content: <<EOH
[
  {
    "destinationTable": "Transactions.submitter",
    "displayFormat": "{_id} - {first_name} {last_name}",
    "displayTitle": "Currently Logged On",
    "displayType": "logged_on",
    "metaID": "logon",
    "queryDependency": {},
    "queryFields": [
      "first_name",
      "last_name",
      "_id"
    ],
    "sourceTable": "users",
    "value": "",
    "valueField": "_id"
  },
  {
    "destinationTable": "Transactions.proposal",
    "displayFormat": "{_id} - {title}",
    "displayTitle": "Proposal ID",
    "displayType": "select",
    "metaID": "proposal",
    "queryDependency": {
      "instrument_id": "instrument"
    },
    "queryFields": [
      "_id",
      "title"
    ],
    "sourceTable": "proposals",
    "value": "",
    "valueField": "_id"
  },
  {
    "destinationTable": "Transactions.instrument",
    "displayFormat": "{_id} {name_short} - {display_name}",
    "displayTitle": "Instrument ID",
    "displayType": "select",
    "metaID": "instrument",
    "queryDependency": {},
    "queryFields": [
      "_id",
      "name_short",
      "display_name"
    ],
    "sourceTable": "instruments",
    "value": "",
    "valueField": "_id"
  },
  {
    "destinationTable": "TransactionKeyValue",
    "displayFormat": "{_id} - {first_name} {last_name}",
    "displayTitle": "User ID the data is for",
    "displayType": "select",
    "key": "User of Record",
    "metaID": "user-of-record",
    "queryDependency": {
      "proposal_id": "proposal"
    },
    "queryFields": [
      "first_name",
      "last_name",
      "_id"
    ],
    "sourceTable": "users",
    "value": "",
    "valueField": "_id"
  },
  {
    "destinationTable": "NothingReally",
    "directoryOrder": 0,
    "displayFormat": "Proposal ID {_id}",
    "displayType": "directoryTree",
    "metaID": "directory-proposal",
    "queryDependency": {
      "_id": "proposal"
    },
    "queryFields": [
      "_id"
    ],
    "sourceTable": "proposals",
    "value": "",
    "valueField": "_id"
  }
]
EOH
      }
    }
    property :service_disabled, [TrueClass, FalseClass], default: true
  end
end
