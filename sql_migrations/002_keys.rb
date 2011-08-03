Sequel.migration do
  up do
    create_table(:keys) do
      String :key, :primary_key => true
      Int :expansion, :null => false
    end
  end

  down do
    drop_table(:keys)
  end
end
