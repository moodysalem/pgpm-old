package com.moodysalem.pgpmessager.hibernate;

import com.moodysalem.hibernate.model.BaseEntity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Lob;

@Entity
public class Entry extends BaseEntity {

    @Column(name = "secret")
    private String secret;

    @Column(name = "adminSecret")
    private String adminSecret;


    @Column(name = "email")
    private String email;
    @Lob
    @Column(name = "publicKey")
    private String publicKey;

    public String getSecret() {
        return secret;
    }

    public void setSecret(String secret) {
        this.secret = secret;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPublicKey() {
        return publicKey;
    }

    public void setPublicKey(String publicKey) {
        this.publicKey = publicKey;
    }

    public String getAdminSecret() {
        return adminSecret;
    }

    public void setAdminSecret(String adminSecret) {
        this.adminSecret = adminSecret;
    }
}
