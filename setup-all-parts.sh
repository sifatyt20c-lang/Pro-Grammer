#!/bin/bash
echo "🚀 Setting up Full Stack Open Curriculum (Part 0 to Part 14)..."

# রুট ফোল্ডারে যাওয়া নিশ্চিত করা
cd ~/fullstack-clean 2>/dev/null || cd ~

# ১ থেকে ১৪ পর্যন্ত সমস্ত ফোল্ডার স্ট্রাকচার তৈরি
mkdir -p part0 part1 part2/phonebook part3/phonebook part4/bloglist part5/bloglist-frontend part6/redux-anecdotes part7/routed-anecdotes part8/library-frontend part9/typescript-app part10/react-native part11/ci-cd part12/containers part13/node-postgres part14/end-to-end-testing

# --- Part 0: Fundamentals of Web Apps ---
cat << 'P0' > part0/README.md
# Part 0: Fundamentals of Web Apps
- 0.4: New note diagram
- 0.5: Single page app diagram
- 0.6: New note in Single page app diagram
P0

# --- Part 1: Introduction to React ---
cat << 'P1' > part1/README.md
# Part 1: Introduction to React
- courseinfo, unicafe, anecdotes apps
P1

# --- Part 2: Communicating with server (Phonebook) ---
cat << 'PKG2' > part2/phonebook/package.json
{
  "name": "phonebook-frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": { "dev": "vite", "build": "vite build" },
  "dependencies": { "react": "^18.2.0", "react-dom": "^18.2.0" },
  "devDependencies": { "@vitejs/plugin-react": "^4.2.1", "vite": "^5.2.0" }
}
PKG2
mkdir -p part2/phonebook/src
cat << 'APP2' > part2/phonebook/src/App.jsx
import { useState, useEffect } from 'react'
const App = () => {
  const [persons, setPersons] = useState([])
  useEffect(() => {
    fetch('/api/persons').then(res => res.json()).then(data => setPersons(data))
  }, [])
  return (
    <div>
      <h2>Phonebook Part 2</h2>
      {persons.map(p => <div key={p.id}>{p.name} {p.number}</div>)}
    </div>
  )
}
export default App
APP2

# --- Part 3: Programming a server with NodeJS and Express ---
cat << 'PKG3' > part3/phonebook/package.json
{
  "name": "phonebook-backend",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": { "start": "node index.js", "dev": "node --watch index.js" },
  "dependencies": { "cors": "^2.8.5", "express": "^4.19.2" }
}
PKG3
cat << 'IDX3' > part3/phonebook/index.js
const express = require('express')
const cors = require('cors')
const app = express()
app.use(express.json())
app.use(cors())
let persons = [{ id: "1", name: "Arto Hellas", number: "040-123456" }]
app.get('/api/persons', (req, res) => res.json(persons))
const PORT = process.env.PORT || 3001
app.listen(PORT, () => console.log(`Server on port ${PORT}`))
IDX3

# --- Part 4 to Part 14 Base Structure Placeholders ---
for i in {4..14}; do
  mkdir -p part$i
  echo "# Part $i Curriculum Exercises" > part$i/README.md
done

echo "✅ All Parts (0 to 14) structure successfully generated!"
