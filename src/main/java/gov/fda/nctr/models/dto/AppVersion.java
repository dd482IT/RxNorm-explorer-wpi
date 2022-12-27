package gov.fda.nctr.models.dto;

import org.checkerframework.checker.nullness.qual.Nullable;
import com.fasterxml.jackson.annotation.JsonAlias;


public class AppVersion
{
  private String buildTimestamp;

  private String buildUserEmail;

  private String buildUserName;

  private String commitId;

  private String commitTimestamp;

  public AppVersion()
  {
  }

  public String getBuildTimestamp()
  {
    return buildTimestamp;
  }

  public String getBuildUserEmail()
  {
    return buildUserEmail;
  }

  public String getBuildUserName()
  {
    return buildUserName;
  }

  public String getCommitId()
  {
    return commitId;
  }

  public String getCommitTimestamp()
  {
    return commitTimestamp;
  }

  @Override
  public String toString()
  {
    return "{" +
      "buildTimestamp=" + buildTimestamp +
      ", buildUserEmail='" + buildUserEmail + '\'' +
      ", buildUserName='" + buildUserName + '\'' +
      ", commitId='" + commitId + '\'' +
      ", commitTimestamp=" + commitTimestamp +
      '}';
  }
}
