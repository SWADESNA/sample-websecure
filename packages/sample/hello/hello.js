function main(args) {
    let name = args.name || 'stranger'
    let greeting = 'Hello ' + name + '!\n'
    console.log(greeting)
    return {"body": greeting}
  }
  
