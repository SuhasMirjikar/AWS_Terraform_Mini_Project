package com.example.conversations.controller;

import com.example.conversations.model.Conversation;
import com.example.conversations.repository.ConversationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/conversations")
public class ConversationController {

    @Autowired
    private ConversationRepository repository;

    @PostMapping
    public Conversation create(@RequestBody Conversation conversation) {
        conversation.setCreatedAt(java.time.LocalDateTime.now());
        return repository.save(conversation);
    }

    @GetMapping
    public List<Conversation> getAll() {
        return repository.findAll();
    }

    @GetMapping("/{id}")
    public Conversation getById(@PathVariable Long id) {
        Optional<Conversation> conversation = repository.findById(id);
        return conversation.orElse(null);
    }

    @PutMapping("/{id}")
    public Conversation update(
            @PathVariable Long id,
            @RequestBody Conversation conversation) {
        Optional<Conversation> existing = repository.findById(id);
        if (existing.isPresent()) {
            Conversation c = existing.get();
            c.setTitle(conversation.getTitle());
            c.setContent(conversation.getContent());
            c.setUpdatedAt(java.time.LocalDateTime.now());
            return repository.save(c);
        } else {
            return null;
        }
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Long id) {
        repository.deleteById(id);
    }
}
