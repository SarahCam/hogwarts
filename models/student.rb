require_relative('../db/sql_runner.rb')

class Student

  attr_reader :id, :first_name, :last_name, :house, :age

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @first_name = options['first_name']
    @last_name = options['last_name']
    @house = options['house'].to_i
    @age = options['age'].to_i
  end

  def save()
    sql = "INSERT INTO students (first_name, last_name, house, age)
           VALUES ($1, $2, $3, $4) RETURNING *"
    values = [@first_name, @last_name, @house, @age]
    save = SqlRunner.run(sql, values)
    @id = save.first()['id'].to_i
  end


  def self.find_by_id(id)
    sql = "SELECT * FROM students WHERE id = $1"
    values = [id]
    student = SqlRunner.run(sql, values)[0]
    return Student.new(student)
  end

  def self.all()
    sql = "SELECT * FROM students"
    students = SqlRunner.run(sql)
    return students.map{|student| Student.new(student)}
  end

  def self.delete_all()
    sql = "DELETE FROM students"
    SqlRunner.run(sql)
  end


end
