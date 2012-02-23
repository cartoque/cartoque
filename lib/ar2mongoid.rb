# active_record 2 mongo migration helpers
class AR2Mongoid
  def self.mongoid_type(col)
    return col.klass  if [String,Time,Date,Float,BigDecimal].include?(col.klass)
    return Boolean    if col.type == :boolean
    return BigDecimal if col.type == :integer && col.sql_type.match(/bigint/) && col.limit > 8 #mongo can store 8-bytes integers by default
    return Integer    if col.type == :integer
  end
end
