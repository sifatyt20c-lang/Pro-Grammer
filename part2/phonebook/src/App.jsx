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
