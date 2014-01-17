require_relative 'feature_grader'

class HW3Grader < FeatureGrader

  @assignment_id = '3'

  # Parse out a -m option in Grader? Move to parent if common with HW4.
  @multithread   = true

  # Pass raw args to take advantage of method signature arity validation.
  def self.format_cli(t_option, type, a_option, base_app_path, archive, hw3_yml)
    spec_hash = {:description => hw3_yml}
    spec_hash[:mt] = @multithread
    @base_app_path = base_app_path
    return @assignment_id, type, archive, spec_hash
  end

end