# Simple Employee Class Hierarchy (Version #2)
# H. C. Cunningham
# 11 September 2006

# Define a class named "Employee" that will be base class to be extended
# below. 

class Employee

  @@nextid = 1    # Class variable names begin with "@@".
                  # Exactly one copy for entire class.

  # Initialize instance variables (i.e., attributes).  
  # Called as: Employee.new(first,last,dept,boss)

    # Note: Instance variables are variables for which each object
    # (instance) has a unique copy.  The names of the instance variables
    # begin with "@".  

    # Note: Parameter names and variable names local to a method begin
    # with an alphabetic character.

  def initialize(first,last,dept,boss) 
    @fname      = first 
    @lname      = last 
    @deptid     = dept 
    @supervisor = boss 
    @empid      = @@nextid 
    @@nextid    = @@nextid + 1    # increment employee counter
  end

  # Mutator methods (attribute writers) 

    # Note: We could use 
    #     attr_writer :dept_id, :supervisor
    # to create writer methods "deptid=" and "supervisor=" methods, which
    # would enable overloading of assignment operator.  However, be careful
    # because this can sometimes expose the internal structure that you may
    # later want to change.

  def set_deptid(dept); @deptid = dept; end
    # Note: Semicolons in the above separate multiple commands on a line.

  def set_supervisor(boss); @supervisor = boss;  end

    # Note: Mutators are intentionally omitted for "fname", "lname", and
    # "empid" fields because those are meant to be immutable once created.
    # A new "Employee" object can be created if needed.

  # Accessor methods (attribute readers)

    # Note: The value of last command in a method is the object returned.
    # Can use explicit "return" command to terminate and return value.

  def get_name
    @lname.to_s + ", " + @fname.to_s
    # calls to_s on each in case not already String
  end

    # Note: We could use 
    #     attr_reader :empname, :dept_id, :supervisor
    # to generate the three accessors with same name as base instance
    # variable name.  However, be careful because that can sometimes expose
    # internal that you later want to change.

  def get_empid; @empid; end

  def get_deptid; @deptid; end

  def get_supervisor; @supervisor; end

  # Override "to_s" method from Object.

  def to_s
    @empid.to_s + " : " + get_name.to_s + " : " + @deptid.to_s + 
                   " (" + @supervisor.to_s + ")"
    # Note local call to "get_name" above.  Develop target is this object.
  end

end

class Staff < Employee

  attr_accessor :title  # generate both reader and writer

    # Note: Above results in inconsistent naming of readers/writers 
    # from "Employee" but are included here as an example.

  def initialize(first,last,dept,boss,title)
    super(first,last,dept,boss)    # call parent initialize method
    @title = title
  end

  # Override Employee#to_s but call up to Employee's method in doing so.
  def to_s
    super.to_s + ", " + @title.to_s
  end

end

class Professor < Staff

  attr_accessor :tenure_status  # generate both reader and writer

    # Note : The above results in inconsistent naming of readers/writers 
    # to those we used in Employee, but it is included here as an example.

  def initialize(first,last,dept,boss,title,tenure)
    super(first,last,dept,boss,title)
    @tenure_status = tenure
  end

  def to_s
    super.to_s + ", " + @tenure_status.to_s
  end

end

class Manager

  attr_reader   :emp, :dept
  attr_accessor :sec

  def initialize(emp,dept,sec)
    @emp  = emp
    @dept = dept
    @sec  = sec
  end

  def to_s
    "Manager(" + @emp.to_s + ") of " + @dept.to_s + " with admin (" + 
      @sec.to_s + ")"
  end

end

# global variables (to enable some experimentation outside file)
$p1 = Professor.new("Jane","Smith","CS","Dean","Professor","tenured")
$s1 = Staff.new("Oliver","Jones","PPD","Weazel","gofer")
$s2 = Staff.new("Joanie","Jones","CS",$p1.get_name,"receptionist")
$m1 = Manager.new($p1,$p1.get_deptid,$s2)

class TestEmployee

  # Class method TestEmployee
  # Call "TestEmployee.do_test" to do some tests of the classes defined in
  # this file.

  def TestEmployee.do_test
    puts "$p1.class          ==> " + $p1.class.to_s
    puts "$p1.to_s           ==> " + $p1.to_s
    puts "$p1.get_empid      ==> " + $p1.get_empid.to_s
    puts "$s1.class          ==> " + $s1.class.to_s
    puts "$s1.to_s           ==> " + $s1.to_s
    puts "$s1.get_empid      ==> " + $s1.get_empid.to_s
    puts "$s2.class          ==> " + $s2.class.to_s
    puts "$s2.to_ss          ==> " + $s2.to_s
    puts "$s2.get_empid      ==> " + $s2.get_empid.to_s
    puts "$m1.class          ==> " + $m1.class.to_s
    puts "$m1.to_s           ==> \n" + $m1.to_s
    puts "p = $p1            ==> " + (p = $p1).to_s
    puts "p.tenure_status    ==> " + p.tenure_status.to_s
    puts "p.tenure_status = \"retired\" ==> " + 
         (p.tenure_status = "retired").to_s
    puts "p.tenure_status    ==> " + p.tenure_status.to_s
    puts "p.title            ==> " + p.title.to_s
    puts "p.title = \"Associate Profesor\" ==> " + 
         (p.title = "Associate Professor").to_s
    puts "p.title            ==> " + p.title.to_s
    puts "p.get_name         ==> " + p.get_name
    puts "p.get_deptid       ==> " + p.get_deptid.to_s
    puts "p.set_deptid(\"EE\") ==> " + p.set_deptid("EE").to_s
    puts "p.get_deptid       ==> " + p.get_deptid.to_s 
    puts "p.get_supervisor   ==> " + p.get_supervisor.to_s
    puts "p.set_supervisor(\"Provost\")  ==> " + 
          p.set_supervisor("Provost").to_s
    puts "p.get_supervisor   ==> " + p.get_supervisor.to_s
    puts "m = $m1            ==>\n" + (m = $m1).to_s
    puts "me = m.emp         ==>\n" + (me = m.emp).to_s
    puts "me.set_supervisor(\"G\") ==> " + (me.set_supervisor("G")).to_s
    puts "m.emp              ==> " + m.emp.to_s
    puts "m.dept             ==> " + m.dept.to_s
    puts "m.sec              ==> " + m.sec.to_s
    puts "m.sec = $s1        ==> " + (m.sec = $s1).to_s
    puts "m.sec              ==> " + m.sec.to_s
  end

end
