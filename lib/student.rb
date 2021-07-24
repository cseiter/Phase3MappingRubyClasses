class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  attr_accessor :name, :grade
  attr_reader :id

  def initialize(name,grade,id=nil)
    @name=name
    @grade=grade
    @id=id
  end

  def self.create_table
    sql_create_tbl_students = <<-SQL
    create table if not exists students(
      id INTEGER primary key,
      name text,
      grade number
    )
    SQL
    DB[:conn].execute(sql_create_tbl_students)
  end

  def self.drop_table
    sql_drop_tbl_students = <<-SQL
    drop table if exists students
    SQL
    DB[:conn].execute(sql_drop_tbl_students)
  end

  def save
    sql_save_students = <<-SQL
    insert into students(name,grade)
    values(?,?)
    SQL
    DB[:conn].execute(sql_save_students, self.name,self.grade)
    @id = DB[:conn].execute("select last_insert_rowid() from students")[0][0]
  end

  def self.create(name:,grade:)
    new_student = Student.new(name,grade)
    new_student.save
    new_student
  end

end
