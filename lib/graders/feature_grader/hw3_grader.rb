require_relative 'feature_grader'

class HW3Grader < FeatureGrader

  def self.format_cli(t_opt, type, a_opt, dir, archive, hw_yml)
    ENV['ASSIGNMENT_ID'] = '3'
    return [ENV['ASSIGNMENT_ID'], type, archive, {:spec => hw_yml}]
  end
end
