package io.pgpm.hibernate;

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

    @Column(name = "mailtoLink")
    private boolean mailtoLink;

    @Lob
    @Column(name = "publicKey")
    private String publicKey;

    @Column(name = "deleted")
    private boolean deleted;

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

    public boolean isMailtoLink() {
        return mailtoLink;
    }

    public void setMailtoLink(boolean mailtoLink) {
        this.mailtoLink = mailtoLink;
    }

    public boolean isDeleted() {
        return deleted;
    }

    public void setDeleted(boolean deleted) {
        this.deleted = deleted;
    }
}
