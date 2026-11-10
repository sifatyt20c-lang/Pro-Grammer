const { ApolloServer } = require('@apollo/server')
const { startStandaloneServer } = require('@apollo/server/standalone')

let authors = [
  { name: 'Robert Martin', id: 'afa51ab0-344d-11e9-a414-719c6709cf3e', born: 1952 },
  { name: 'Martin Fowler', id: 'afa51ab1-344d-11e9-a414-719c6709cf3e', born: 1963 },
  { name: 'Fyodor Dostoevsky', id: 'afa51ab2-344d-11e9-a414-719c6709cf3e', born: 1821 }
]

let books = [
  { title: 'Clean Code', published: 2008, author: 'Robert Martin', id: 'afa51ab3-344d-11e9-a414-719c6709cf3e', genres: ['refactoring'] },
  { title: 'Agile software development', published: 2002, author: 'Robert Martin', id: 'afa51ab4-344d-11e9-a414-719c6709cf3e', genres: ['agile', 'patterns'] }
]

const typeDefs = `
  type Author {
    name: String!
    id: ID!
    born: Int
    bookCount: Int
  }

  type Book {
    title: String!
    published: Int!
    author: String!
    id: ID!
    genres: [String!]!
  }

  type Query {
    bookCount: Int!
    authorCount: Int!
    allBooks(author: String, genre: String): [Book!]!
    allAuthors: [Author!]!
  }

  type Mutation {
    addBook(
      title: String!
      author: String!
      published: Int!
      genres: [String!]!
    ): Book
  }
`

const resolvers = {
  Query: {
    bookCount: () => books.length,
    authorCount: () => authors.length,
    allBooks: (root, args) => {
      let filtered = books
      if (args.author) {
        filtered = filtered.filter(b => b.author === args.author)
      }
      if (args.genre) {
        filtered = filtered.filter(b => b.genres.includes(args.genre))
      }
      return filtered
    },
    allAuthors: () => authors.map(author => ({
      ...author,
      bookCount: books.filter(b => b.author === author.name).length
    }))
  },
  Mutation: {
    addBook: (root, args) => {
      const book = { ...args, id: String(Math.floor(Math.random() * 1000000)) }
      books.push(book)
      if (!authors.find(a => a.name === args.author)) {
        authors.push({ name: args.author, id: String(Math.floor(Math.random() * 1000000)) })
      }
      return book
    }
  }
}

const server = new ApolloServer({ typeDefs, resolvers })

startStandaloneServer(server, { listen: { port: 4000 } }).then(({ url }) => {
  console.log(`Server ready at ${url}`)
})
