# Peeky

> Peeky is a Ruby GEM for peaking into ruby classes and extracting meta

As a Ruby Developer, I should be able to Reverse engineer classes and methods, so that I can document and understand them

## Stories

As a Developer, I can render a class with instance attributes and methods, So that I can quickly mock out an entire class

- Render: Class Interface

As a Developer, I can render method signature with debug code, So that mock out a method with parameter logging

- Render: Method signature with debug code

As a Developer, I can see the method signature of a method, So that I understand it&#x27;s parameters

- Render: Method Signature in compact format

As a Developer, I can render method with minimal parameter calls, So that I know the minimum parameters when calling a method

- Render: Simple instance method calls with minimum parameters

As a Developer, I can tell if a method is attr_*, so that I can format methods using attr_* notation

- Attr Writer Predicate will match true if the method info could be considered a valid attr_writer
- Attr Writer Predicate will match true if the method info could be considered a valid attr_writer

As a Developer, I should be able to interrogate class instance information, so that I can reverse engineer a ruby class

- ParameterInfo model to store information about parameters on a method
- MethodInfo model to store signature of a ruby instance method
- AttrInfo is a container that represents attr_reader, attr_writer or attr_accessor by storying 1 or 2 MethodInfo
- ClassInfo stores information about a ruby class. Only support instance methods


## Tasks


Setup GitHub Action (test and lint)

- Setup Rspec action
- Setup RuboCop action


Setup new Ruby GEM

- Build out a standard GEM structure
- Add semantic versioning
- Add Rspec unit testing framework
- Add RuboCop linting
- Add Guard for automatic watch and test
- Add GitFlow support
- Add GitHub Repository
