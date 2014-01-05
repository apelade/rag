require_relative 'feature_grader'

class HW3Grader < FeatureGrader

  def self.format_cli(t_opt, type, a_opt, dir, archive, hw_yml)
    ENV['ASSIGNMENT_ID'] = '3'
    spec_hash = {:spec => hw_yml}
    super t_opt, type, archive, spec_hash
  end
end
