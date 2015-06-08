require "pg"

$db = PG.connect(
  dbname: 'jaden_forum'
)
