import { createSlice } from '@reduxjs/toolkit'

const anecdoteSlice = createSlice({
  name: 'anecdotes',
  initialState: [
    { id: '1', content: 'If it hurts, do it more often', votes: 0 },
    { id: '2', content: 'Adding manpower to a late software project makes it later!', votes: 0 }
  ],
  reducers: {
    voteAnecdote(state, action) {
      const id = action.payload
      const anecdoteToChange = state.find(n => n.id === id)
      if (anecdoteToChange) {
        anecdoteToChange.votes++
      }
    },
    appendAnecdote(state, action) {
      state.push(action.payload)
    }
  }
})

export const { voteAnecdote, appendAnecdote } = anecdoteSlice.actions
export default anecdoteSlice.reducer
