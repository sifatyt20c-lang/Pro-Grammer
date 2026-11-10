const express = require('express')
const cors = require('cors')
const app = express()
app.use(express.json())
app.use(cors())
let persons = [{ id: "1", name: "Arto Hellas", number: "040-123456" }]
app.get('/api/persons', (req, res) => res.json(persons))
const PORT = process.env.PORT || 3001
app.listen(PORT, () => console.log(`Server on port ${PORT}`))
