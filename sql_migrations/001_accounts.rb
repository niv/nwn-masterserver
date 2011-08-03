Sequel.migration do
  up do
    create_table(:accounts) do
      String :account, :primary_key => true

      String :password, :null => false
    end
  end

  down do
    drop_table(:accounts)
  end
end
