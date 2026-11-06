"""Fail-closed policy boundary for active security operations."""
from dataclasses import dataclass
from typing import Iterable


class AuthorizationError(PermissionError):
    pass


@dataclass(frozen=True)
class Scope:
    engagement: str
    targets: frozenset[str]
    source: str
    allowed_actions: frozenset[str]
    exclusions: frozenset[str] = frozenset()
    rate_limit: str = ""
    explicit_high_impact: frozenset[str] = frozenset()


@dataclass(frozen=True)
class Action:
    kind: str
    targets: tuple[str, ...] = ()
    active: bool = True
    high_impact: bool = False


def authorize(action: Action, scope: Scope | None) -> None:
    """Allow passive preparation; require explicit, matching scope for active operations."""
    if not action.active:
        return
    if scope is None or not scope.source.strip() or not scope.targets:
        raise AuthorizationError("active action requires an authorization source and explicit target scope")
    if action.kind not in scope.allowed_actions:
        raise AuthorizationError(f"action {action.kind!r} is not allowed by the engagement scope")
    if action.high_impact and action.kind not in scope.explicit_high_impact:
        raise AuthorizationError(f"high-impact action {action.kind!r} requires explicit authorization")
    if not action.targets or any(t not in scope.targets or t in scope.exclusions for t in action.targets):
        raise AuthorizationError("every active target must be explicitly in scope and not excluded")


def authorize_workflow(actions: Iterable[Action], scope: Scope | None) -> None:
    for action in actions:
        authorize(action, scope)
