def branches = [:]

for (int i = 0; i < 10; i++) {
  def index = i  // needed for correct closure capture
  branches["branch${index}"] = {
    node {
      retry(3) {
        checkout scm
      }
      echo "hello world ${index}"
    }
  }
}

retry(3) {
  parallel branches
}
