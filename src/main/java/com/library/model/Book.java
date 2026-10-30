package com.library.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Book implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String title;
    private String author;
    private String category;
    private String isbn;
    private String publisher;
    private int quantity;
    private int availableCopies;
    private String coverImage;
    private String description;
    private Timestamp createdAt;

    public Book() {}

    public Book(String title, String author, String category, String isbn, String publisher,
                int quantity, int availableCopies, String coverImage, String description) {
        this.title = title;
        this.author = author;
        this.category = category;
        this.isbn = isbn;
        this.publisher = publisher;
        this.quantity = quantity;
        this.availableCopies = availableCopies;
        this.coverImage = coverImage;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getIsbn() {
        return isbn;
    }

    public void setIsbn(String isbn) {
        this.isbn = isbn;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getAvailableCopies() {
        return availableCopies;
    }

    public void setAvailableCopies(int availableCopies) {
        this.availableCopies = availableCopies;
    }

    public String getCoverImage() {
        return coverImage;
    }

    public void setCoverImage(String coverImage) {
        this.coverImage = coverImage;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

