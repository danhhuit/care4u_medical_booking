using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Care4U.Api.Models;

[Table("password_reset_otps")]
public class PasswordResetOtp
{
    [Key]
    [Column("id")]
    public Guid Id { get; set; }

    [Column("user_id")]
    public Guid UserId { get; set; }

    [Column("otp_hash")]
    public string OtpHash { get; set; } = string.Empty;

    [Column("delivery_target")]
    public string DeliveryTarget { get; set; } = string.Empty;

    [Column("delivery_type")]
    public string DeliveryType { get; set; } = string.Empty;

    [Column("expires_at")]
    public DateTime ExpiresAt { get; set; }

    [Column("verified_at")]
    public DateTime? VerifiedAt { get; set; }

    [Column("used_at")]
    public DateTime? UsedAt { get; set; }

    [Column("reset_token")]
    public Guid? ResetToken { get; set; }

    [Column("reset_token_expires_at")]
    public DateTime? ResetTokenExpiresAt { get; set; }

    [Column("created_at")]
    public DateTime CreatedAt { get; set; }

    public virtual User User { get; set; } = null!;
}