package com.gu.model.dto;

public class FavoriteToggleResponse {
    private Long productId;
    private boolean isFavorited;

    public FavoriteToggleResponse(Long productId, boolean isFavorited) {
        this.productId = productId;
        this.isFavorited = isFavorited;
    }

    public Long getProductId() { return productId; }
    public boolean isFavorited() { return isFavorited; }
}