package com.example.conversations.repository;

import com.example.conversations.model.Conversation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ConversationRepository
        extends JpaRepository<Conversation, Long> {
}
