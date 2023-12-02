module CmsAdapter
  def fetch_data(database_type)
    raise NotImplementedError, "Subclasses must implement the fetch_data method"
  end

  def transform_record(record, transform_function)
    raise NotImplementedError, "Subclasses must implement the transform_record method"
  end
end
