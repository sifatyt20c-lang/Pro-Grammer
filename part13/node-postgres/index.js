const express = require('express')
const { Sequelize, DataTypes } = require('sequelize')
const app = express()

const sequelize = new Sequelize(process.env.DATABASE_URL || 'postgres://postgres:postgres@localhost:5432/postgres')

const Blog = sequelize.define('Blog', {
  id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  author: { type: DataTypes.TEXT },
  url: { type: DataTypes.TEXT, allowNull: false },
  title: { type: DataTypes.TEXT, allowNull: false },
  likes: { type: DataTypes.INTEGER, defaultValue: 0 }
})

app.get('/api/blogs', async (req, res) => {
  try {
    const blogs = await Blog.findAll()
    res.json(blogs)
  } catch (error) {
    res.status(500).json({ error: error.message })
  }
})

const PORT = process.env.PORT || 3001
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`)
})
