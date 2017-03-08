# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
require IEx
alias Whale2.{Repo, User, Question, Comment, Relationship, Answer, Like}

# Create Users
eliel = Repo.insert! %User{
    first_name: "Eliel",
    last_name: "Gordon",
    email: "gordoneliel@gmail.com",
    username: "gordoneliel",
    password: "example"
}

chase = Repo.insert! %User{
    first_name: "Chase",
    last_name: "Wang",
    email: "chase@ocwang.com",
    username: "cwang",
    password: "example"
}

peter = Repo.insert! %User{
    first_name: "Peter",
    last_name: "Smith",
    email: "peter@mail.com",
    username: "peter_smith",
    password: "example"
}

helen = Repo.insert! %User{
    first_name: "Helen",
    last_name: "Farnsworth",
    email: "helen@mail.com",
    username: "helen_farnsworth",
    password: "example"
}

keith = Repo.insert! %User{
    first_name: "Keith",
    last_name: "Barnes",
    email: "keith@mail.com",
    username: "keith_barnes",
    password: "example"
}

# Create some relationships
eliel_to_chase = Repo.insert! %Relationship{
    follower: eliel,
    followed: chase
}

eliel_to_keith = Repo.insert! %Relationship{
    follower: eliel,
    followed: keith
}

helen_to_eliel = Repo.insert! %Relationship{
    follower: helen,
    followed: eliel
}

chase_to_peter = Repo.insert! %Relationship{
    follower: chase,
    followed: peter
}

chase_to_helen = Repo.insert! %Relationship{
    follower: chase,
    followed: helen
}

peter_to_chase = Repo.insert! %Relationship{
    follower: peter,
    followed: chase
}

# Questions
question1 = Repo.insert! %Question{
    content: "What kind of food do you like?",
    categories: ["lifestyle", "food"],
    sender: eliel,
    receiver: chase
}

question2 = Repo.insert! %Question{
    content: "What was your very first job and what did you learn from it?",
    categories: ["lifestyle", "startups", "investing"],
    sender: helen,
    receiver: eliel
}

question3 = Repo.insert! %Question{
    content: "What makes a live experience sticky? What do people talk about after its been over for an hour, day, month, year?",
    categories: ["tech", "design"],
    sender: peter,
    receiver: chase
}

question4 = Repo.insert! %Question{
    content: "With rental prices souring in places like silicon valley, what will happen to startup hubs when the cost of living is a barrier to entrepreneurs?",
    categories: ["lifestyle", "tech", "housing"],
    sender: keith,
    receiver: eliel
}

# Answers
answer1 = Repo.insert! %Answer{
    question: question1
}

answer2 = Repo.insert! %Answer{
    question: question2
}

# Comments
comment1 = Repo.insert! %Comment{
    content: "This is great content",
    commenter: eliel,
    answer: answer1
}

comment2 = Repo.insert! %Comment{
    content: "I like food!",
    commenter: chase,
    answer: answer1
}

comment3 = Repo.insert! %Comment{
    content: "Some random comment!",
    commenter: keith,
    answer: answer2
}

comment4 = Repo.insert! %Comment{
    content: "Yay",
    commenter: peter,
    answer: answer2
}

# Likes
like1 = Repo.insert! %Like{
    answer: answer1,
    user: eliel
}

like2 = Repo.insert! %Like{
    answer: answer1,
    user: keith
}

like3 = Repo.insert! %Like{
    answer: answer2,
    user: chase
}

like4 = Repo.insert! %Like{
    answer: answer1,
    user: helen
}
