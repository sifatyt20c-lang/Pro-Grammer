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
