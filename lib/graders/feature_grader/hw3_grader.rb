require_relative 'feature_grader'

class HW3Grader < FeatureGrader

  @assignment_id = '3'

  def self.format_cli(t_option, type, a_option, dir, archive, hw_yml)
    spec_hash = {:spec => hw_yml}
    return @assignment_id, type, archive, spec_hash
  end
end
