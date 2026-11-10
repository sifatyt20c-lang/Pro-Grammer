#!/bin/bash
echo "🚀 Setting up Part 2 & Part 3 with proper official structure..."

# ১. Part 2: Phonebook Frontend (part1 এর আদলে সরাসরি App.jsx স্ট্রাকচার)
mkdir -p part2/phonebook/src
mkdir -p part3/phonebook

# Part 2 package.json
cat << 'PKG2' > part2/phonebook/package.json
{
  "name": "phonebook-frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@vitejs/plugin-react": "^4.2.1",
    "vite": "^5.2.0"
  }
}
PKG2

# Part 2 index.html
cat << 'HTM2' > part2/phonebook/index.html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Phonebook Part 2</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
HTM2

# Part 2 vite.config.js
cat << 'VIT2' > part2/phonebook/vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:3001',
        changeOrigin: true,
      },
    },
  },
})
VIT2

# Part 2 main.jsx
cat << 'MAIN2' > part2/phonebook/src/main.jsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
MAIN2

# Part 2 App.jsx
cat << 'APP2' > part2/phonebook/src/App.jsx
import { useState, useEffect } from 'react'

const App = () => {
  const [persons, setPersons] = useState([])
  const [newName, setNewName] = useState('')
  const [newNumber, setNewNumber] = useState('')
  const [filter, setFilter] = useState('')

  useEffect(() => {
    fetch('/api/persons')
      .then(response => response.json())
      .then(data => setPersons(data))
  }, [])

  const addPerson = (event) => {
    event.preventDefault()
    const existing = persons.find(p => p.name === newName)
    if (existing) {
      alert(`${newName} is already added to phonebook`)
      return
    }

    const personObject = { name: newName, number: newNumber }

    fetch('/api/persons', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(personObject)
    })
      .then(response => response.json())
      .then(returnedPerson => {
        setPersons(persons.concat(returnedPerson))
        setNewName('')
        setNewNumber('')
      })
  }

  const deletePerson = (id, name) => {
    if (window.confirm(`Delete ${name}?`)) {
      fetch(`/api/persons/${id}`, { method: 'DELETE' }).then(() => {
        setPersons(persons.filter(p => p.id !== id))
      })
    }
  }

  const personsToShow = filter
    ? persons.filter(p => p.name.toLowerCase().includes(filter.toLowerCase()))
    : persons

  return (
    <div>
      <h2>Phonebook</h2>
      <div>
        filter shown with <input value={filter} onChange={e => setFilter(e.target.value)} />
      </div>
      <h3>add a new</h3>
      <form onSubmit={addPerson}>
        <div>name: <input value={newName} onChange={e => setNewName(e.target.value)} /></div>
        <div>number: <input value={newNumber} onChange={e => setNewNumber(e.target.value)} /></div>
        <div><button type="submit">add</button></div>
      </form>
      <h3>Numbers</h3>
      {personsToShow.map(person => (
        <div key={person.id}>
          {person.name} {person.number} 
          <button onClick={() => deletePerson(person.id, person.name)}>delete</button>
        </div>
      ))}
    </div>
  )
}

export default App
APP2

# ২. Part 3: Phonebook Backend (Node.js/Express Server)
cat << 'PKG3' > part3/phonebook/package.json
{
  "name": "phonebook-backend",
  "version": "1.0.0",
  "description": "Full Stack Open Part 3 Backend",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "node --watch index.js"
  },
  "dependencies": {
    "cors": "^2.8.5",
    "express": "^4.19.2"
  }
}
PKG3

cat << 'IDX3' > part3/phonebook/index.js
const express = require('express')
const cors = require('cors')
const app = express()

app.use(express.json())
app.use(cors())

let persons = [
  { id: "1", name: "Arto Hellas", number: "040-123456" },
  { id: "2", name: "Ada Lovelace", number: "39-44-5323523" },
  { id: "3", name: "Dan Abramov", number: "12-43-234345" },
  { id: "4", name: "Mary Poppendieck", number: "39-23-6423122" }
]

app.get('/api/persons', (req, res) => {
  res.json(persons)
})

app.get('/api/persons/:id', (req, res) => {
  const id = req.params.id
  const person = persons.find(p => p.id === id)
  if (person) {
    res.json(person)
  } else {
    res.status(404).end()
  }
})

app.delete('/api/persons/:id', (req, res) => {
  const id = req.params.id
  persons = persons.filter(p => p.id !== id)
  res.status(204).end()
})

app.post('/api/persons', (req, res) => {
  const body = req.body
  if (!body.name || !body.number) {
    return res.status(400).json({ error: 'name or number missing' })
  }
  const nameExists = persons.some(p => p.name === body.name)
  if (nameExists) {
    return res.status(400).json({ error: 'name must be unique' })
  }

  const newPerson = {
    id: String(Math.floor(Math.random() * 1000000)),
    name: body.name,
    number: body.number
  }

  persons = persons.concat(newPerson)
  res.json(newPerson)
})

const PORT = process.env.PORT || 3001
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
IDX3

echo "✅ Proper structure created successfully!"
