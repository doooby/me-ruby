module Me::Ti::Table
  attr_reader :records

  # TODO v1.0
  # three visuals characteristics:
  #   - with the table caracters
  #   - hashes as borders (-m)
  #   - fully minimized (-mm)

  def initialize records
    @records = records
  end
end
