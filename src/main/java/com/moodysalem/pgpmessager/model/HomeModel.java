package com.moodysalem.pgpmessager.model;

import com.moodysalem.pgpmessager.hibernate.Entry;

public class HomeModel {

    private Entry entry;
    private String errorMessage;
    private String successMessage;

    public Entry getEntry() {
        return entry;
    }

    public void setEntry(Entry entry) {
        this.entry = entry;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getSuccessMessage() {
        return successMessage;
    }

    public void setSuccessMessage(String successMessage) {
        this.successMessage = successMessage;
    }
}
