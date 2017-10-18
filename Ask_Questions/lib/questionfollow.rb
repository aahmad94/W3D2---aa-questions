class QuestionFollow

  attr_accessor :id, :user_id, :question_id

  def self.find_by_id(id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        question_follows
      WHERE
        id = ?
    SQL
    return nil if hash_result.empty?
    QuestionFollow.new(hash_result.first)
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def self.followers_for_question_id(question_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, question_id)
      SELECT
        users.id, users.fname, users.lname
      FROM
        users
      JOIN
        question_follows ON users.id = question_follows.user_id
      WHERE
        question_follows.question_id = ?
    SQL
    return [] if hash_result.empty?
    hash_result.map { |hash| User.new(hash) }
  end

  def self.followed_questions_for_user_id(user_id)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON questions.author_id = question_follows.user_id
      WHERE
        question_follows.user_id = ?
    SQL
    return [] if hash_result.empty?
    hash_result.map { |hash| Question.new(hash) }
  end

  def self.most_followed_questions(n)
    hash_result = QuestionsDatabase.instance.execute(<<-SQL, n)
      SELECT
        questions.*
      FROM
        question_follows
      JOIN
        questions ON questions.id = question_follows.question_id
      GROUP BY
        question_follows.question_id -- questions.*
      ORDER BY
        COUNT(question_follows.user_id) DESC
      LIMIT
        ?
    SQL
    hash_result.map { |hash| Question.new(hash) }
  end

end
