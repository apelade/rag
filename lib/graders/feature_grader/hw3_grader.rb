require_relative 'feature_grader'

class HW3Grader < FeatureGrader

  @assignment_id = '3'

  # Parse out a -m option in Grader? Move to parent if common with HW4.
  @multithread   = true

  # Pass raw args to take advantage of method signature arity validation.
  def self.format_cli(t_option, type, a_option, base_app_path, archive, hw3_yml)
    spec_hash = {:description => hw3_yml}
    spec_hash[:mt] = @multithread
#    @@base_app_path = base_app_path #HW4Grader takes this from hw4.yml
    return @assignment_id, type, archive, spec_hash
  end

  ##TODO Add student work to standard solution, like HW4Grader
  # TODO Can't see it handled it rag/grade3, so where is it currently done?
  #def grade!
  #end

  def self.feedback(completed_grader)
    g = completed_grader
    score_max = 500
    score_msg = "Score out of #{score_max}: #{g.normalized_score(score_max)}\n"
    comments_msg = "---BEGIN cucumber comments---\n#{'-'*80}\n#{g.comments}\n#{'-'*80}\n---END cucumber comments---"
    return comments_msg + score_msg
  end

end